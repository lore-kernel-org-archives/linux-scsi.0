From: adam radford <aradford@gmail.com>
Subject: Re: [PATCH 1/2] megaraid_sas: Remove the shutdown_controller call
Date: Thu, 25 Aug 2011 17:00:12 -0700
Message-ID: <CAHtARFE+pbaVgbEyxrdF6qyFgu4Km4QOi28wUzfVtc5_SRayAg@mail.gmail.com>
References: <1314200130-28890-1-git-send-email-thenzl@redhat.com>
	<1314200130-28890-2-git-send-email-thenzl@redhat.com>
	<CAHtARFF1iwy2NR1G01hFqBo2hoYxAbG+0DQ0UJNSS3JO_s5qbg@mail.gmail.com>
	<4E560526.5060601@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34977 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753508Ab1HZAAN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Aug 2011 20:00:13 -0400
Received: by ywf7 with SMTP id 7so2228335ywf.19
        for <linux-scsi@vger.kernel.org>; Thu, 25 Aug 2011 17:00:12 -0700 (PDT)
In-Reply-To: <4E560526.5060601@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: linux-scsi@vger.kernel.org, steve.masters@lsi.com, michael.benz@lsi.com, bo.yang@lsi.com

On Thu, Aug 25, 2011 at 1:17 AM, Tomas Henzl <thenzl@redhat.com> wrote:
> In the meantime - I've sent two patches, what do you think about the second one?
> It solves(hides) the problem too.

Here are my thoughts on your patches:

1. You are not checking if (reset_devices) around these code changes
to determine if you are in the kdump kernel, which is the only place
you are seeing this issue.
2. You should only change behavior for the device ID's you are having
issue with.
3. We need to update your PERC5 controller to the latest firmware,
then try to reproduce.

-Adam
