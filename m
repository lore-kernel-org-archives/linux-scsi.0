From: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH #repost] SCSI: megaraid, fix suspend/resume sections
Date: Thu, 01 May 2008 23:34:57 +0200
Message-ID: <481A3781.8080100@gmail.com>
References: <1209657362-20300-1-git-send-email-jirislaby@gmail.com> <20080501142305.77433e50.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.189]:44032 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765808AbYEAVfH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 May 2008 17:35:07 -0400
Received: by fk-out-0910.google.com with SMTP id 18so896227fkq.5
        for <linux-scsi@vger.kernel.org>; Thu, 01 May 2008 14:35:05 -0700 (PDT)
In-Reply-To: <20080501142305.77433e50.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: megaraidlinux@lsi.com, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org

On 05/01/2008 11:23 PM, Andrew Morton wrote:
> On Thu,  1 May 2008 17:56:02 +0200
> Jiri Slaby <jirislaby@gmail.com> wrote:
> 
>> megaraid_sas suspend and resume are inappropriatelly placed in
>> __devinit section.
> 
> That's a box-killer, isn't it?

I think so -- the non-CONFIG_HOTPLUG ones.
