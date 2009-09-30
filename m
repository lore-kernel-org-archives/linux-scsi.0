From: Denys Fedoryschenko <denys@visp.net.lb>
Subject: MPT Fusion SAS 2.6.31 regression, crash on heavy load
Date: Wed, 30 Sep 2009 04:39:05 +0300
Message-ID: <200909300439.05885.denys@visp.net.lb>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hosting.visp.net.lb ([194.146.153.11]:43314 "EHLO
	hosting.visp.net.lb" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827AbZI3Bjg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Sep 2009 21:39:36 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Eric.Moore@lsi.com

Most probably this commit fixes my issue. Very strange that this error didn't 
appear before, it seems it exists at 2.6.30 even?

commit	c55b89fba9872ebcd5ac15cdfdad29ffb89329f0

[SCSI] mptsas : PAE Kernel more than 4 GB kernel panic

This patch is solving problem for PAE kernel DMA operation.
On PAE system dma_addr and unsigned long will have different
values.
Now dma_addr is not type casted using unsigned long.

