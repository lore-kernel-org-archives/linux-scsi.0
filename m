From: James Smart <jsmart2021@gmail.com>
Subject: Re: [PATCH 05/17] lpfc: NVME Initiator: Base modifications Part D
Date: Wed, 18 Jan 2017 19:00:44 -0800
Message-ID: <8d1b6a73-df1a-1fd1-5059-7ce6a7e91c6f@gmail.com>
References: <587ec2f0.FOr4W1UKpsGdXJmP%jsmart2021@gmail.com>
 <20170118133959.GE3514@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:36491 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751815AbdASDBD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jan 2017 22:01:03 -0500
Received: by mail-qt0-f194.google.com with SMTP id l7so5922060qtd.3
        for <linux-scsi@vger.kernel.org>; Wed, 18 Jan 2017 19:00:47 -0800 (PST)
In-Reply-To: <20170118133959.GE3514@linux-x5ow.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org


On 1/18/2017 5:39 AM, Johannes Thumshirn wrote:
> I know this might be annoying by now, but it's really hard to follow 
> code that
> is so much indented and lpfc really needs some love in the readability case.
> Please don't misunderstand me, it has nothing to do with you and lpfc is not
> the only driver that could need some refactoring. It's just I've spend a lot
> of time looking at lpfc since I've started working in the storage area and
> the code style is somewhat inconsistent with the reset of the kernel (as are
> other SCSI drivers, I know). If you and Martin/James B. don't mind I'd even
> volunteer to help you with cleaning it up a bit.

I agree with the idea but want to hold off a little while longer. first, 
I want the driver to stabilize after adding a second protocol. second, I 
want it to harden a bit.

-- james


