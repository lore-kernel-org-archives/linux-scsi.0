From: Matias Bjorling <m@bjorling.me>
Subject: Re: [LSF/MM ATTEND] [LSF/MM TOPIC]
Date: Sat, 10 Jan 2015 17:26:25 +0100
Message-ID: <54B152B1.2070500@bjorling.me>
References: <1420820048.3891.156.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:57588 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393AbbAJQ0e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Jan 2015 11:26:34 -0500
Received: by mail-lb0-f172.google.com with SMTP id z12so12368594lbi.3
        for <linux-scsi@vger.kernel.org>; Sat, 10 Jan 2015 08:26:32 -0800 (PST)
In-Reply-To: <1420820048.3891.156.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: emilne@redhat.com, lsf-pc@lists.linux-foundation.org
Cc: linux-scsi@vger.kernel.org

On 01/09/2015 05:14 PM, Ewan Milne wrote:
> I'd like to attend LSF -- I am responsible for maintaining the SCSI
> subsystem at Red Hat, and in addition to resolving issues for customers
> and partners, I've been participating in upstream development for the
> past couple of years.  I have an extensive background in SCSI and OS
> development, including 15 years of working with the Linux kernel.
> 
> I would also like to have a discussion at LSF/MM 2015 about how we could
> better handle devices whose properties change after being probed. This
> includes:
> 
>   - READ CAPACITY data
>   - ALUA state
>   - EMC OWNED/UNOWNED state
>   - NOT READY state
> 
> Currently, when these properties change, we do not always handle it
> very well (e.g. multipath stops using a path if the capacity changes,
> even if it the only good path to the device...)
> 
> -Ewan Milne <emilne@redhat.com>
> 
> 

I'll like to discuss this as well. Some of these can be beneficial to
open-channel ssds, where the capacity can change dynamically.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

