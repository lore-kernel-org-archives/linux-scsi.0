From: Douglas Gilbert <dougg@torque.net>
Subject: Re: SG_IO inquiry...
Date: Tue, 06 Mar 2007 09:26:13 -0500
Message-ID: <45ED7A05.8080708@torque.net>
References: <868c9d9d0703052359o31394904m76cbc2d04287813f@mail.gmail.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:42602 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965055AbXCFO05 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Mar 2007 09:26:57 -0500
In-Reply-To: <868c9d9d0703052359o31394904m76cbc2d04287813f@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: MASTHAN DUDEKULA <d.mastan@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

MASTHAN DUDEKULA wrote:
> Hi All,
> 
> By using SG_IO ioctl How can we get device related info (like device
> type--disk,tape,cdrom..etc) ?

If you look at http://www.torque.net/sg/sg3_utils.html
and fetch a tarball (e.g. sg3_utils-1.23.tgz) then have
a look at the examples/sg_simple1.c file.

Doug Gilbert


