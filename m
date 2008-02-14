From: Jiri Slaby <jirislaby@gmail.com>
Subject: "gdth: update deprecated pci_find_device" is incorrect
Date: Thu, 14 Feb 2008 15:44:35 +0100
Message-ID: <47B453D3.5060707@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:7163 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757029AbYBNOok (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Feb 2008 09:44:40 -0500
Received: by nf-out-0910.google.com with SMTP id g13so233357nfb.21
        for <linux-scsi@vger.kernel.org>; Thu, 14 Feb 2008 06:44:38 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sergio Luis <sergio@larces.uece.br>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>

Hi,

commit
99109301d103fbf0de43fc5a580a406c12a501e0
in jejb/scsi-rc-fixes-2.6.git is incorrect. You don't decrement pci refcount on 
exit. Also you do not so on fail paths... I wonder why these mistakes happen 
every second time somebody tries to do such change.

It leaked into mainline yet after "whole" two days, but what exactly drives me 
crazy is, that Jeff commented it in similar way and nobody reflected it!


