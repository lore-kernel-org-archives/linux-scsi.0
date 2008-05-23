From: "adam radford" <aradford@gmail.com>
Subject: Re: pci_set_mwi and 3ware controllers
Date: Fri, 23 May 2008 12:39:21 -0700
Message-ID: <b1bc6a000805231239i34731c79h3b29fad00b1e8eb1@mail.gmail.com>
References: <fc593b510805230533lf28171fp24459bf09321500e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:16712 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808AbYEWTj0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 May 2008 15:39:26 -0400
Received: by yw-out-2324.google.com with SMTP id 9so481155ywe.1
        for <linux-scsi@vger.kernel.org>; Fri, 23 May 2008 12:39:21 -0700 (PDT)
In-Reply-To: <fc593b510805230533lf28171fp24459bf09321500e@mail.gmail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Laurent Wandrebeck <l.wandrebeck@gmail.com>
Cc: Tony Battersby <tonyb@cybernetics.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, May 23, 2008 at 5:33 AM, Laurent Wandrebeck
<l.wandrebeck@gmail.com> wrote:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=1e6c38cec08f88b0df88a34e80f15492cace74e9
> patch.
> I have at work a mobo (with 3ware 9650) that doesn't enable mwi by
> default, and running CentOS 5.1 x86_64 (2.6.18 based).
> I can confirm that putting pci_set_mwi just after pci_set_master gives

The 3w-9xxx driver in 2.6.25 already calls 'pci_try_set_mwi(pdev)'.

-Adam
