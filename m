From: Daniel Walker <dwalker@fifo99.com>
Subject: Re: [PATCH 1/12] scsi: megaraid_sas - tape drive support fix
Date: Sun, 20 Sep 2009 20:40:35 -0700
Message-ID: <1253504435.9654.221.camel@desktop>
References: <4B6A08C587958942AA3002690DD4F8C35C5123FA@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fifo99.com ([67.223.236.141]:58739 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753566AbZIUDkl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Sep 2009 23:40:41 -0400
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C35C5123FA@cosmail02.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "akpm@osdl.org" <akpm@osdl.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>


Your patches all have numerous serious style problems.. There are far
too many to even give a summary here, and they are all different kinds
of problems..

You would need to fix all these issues before these patches could move
forward. Could you run scripts/checkpatch.pl on you patches and fix all
the issues that it reports?

Daniel

