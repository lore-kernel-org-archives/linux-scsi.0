From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: [PATCH] instrument ide-scsi in 2.5.68
Date: Thu, 1 May 2003 15:57:07 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030501155707.3a124ec9.rddunlap@osdl.org>
References: <3EB11AD3.2070503@torque.net>
	<20030501155225.7df14e51.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from air-2.osdl.org ([65.172.181.6]:41349 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S262737AbTEAWrG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 May 2003 18:47:06 -0400
In-Reply-To: <20030501155225.7df14e51.rddunlap@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org, alan@lxorguk.ukuu.org.uk

On Thu, 1 May 2003 15:52:25 -0700 "Randy.Dunlap" <rddunlap@osdl.org> wrote:

| 
| Hi Doug,
| 
| I have ATAPI CD-ROM as hdc and CD-RW as hdd.  I boot with
| "hdd=icd-scsi ide-scsi.debug=3".  Is that right/OK so far?
+      ide-scsi
(typo)

--
~Randy
