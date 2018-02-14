From: Laurence Oberman <loberman@redhat.com>
Subject: Re: Fwd: All scsi_debug devices in the scsi_debug driver share the
 same RAM space
Date: Wed, 14 Feb 2018 13:45:20 -0500
Message-ID: <1518633920.11799.1.camel@redhat.com>
References: <1517686992.18584.8.camel@redhat.com>
         <1517841151.11655.1.camel@redhat.com>
         <CAM4Jq_43+JrSTvXsq7kgRLikqHb2iwFMYKTBuQjQ5h2Dn1ka+A@mail.gmail.com>
         <CAM4Jq_5yHhEWU6hvUfJVnCpyCk0QPMHhZ7cY3Eum540124ukeQ@mail.gmail.com>
         <yq11shoqpuy.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f170.google.com ([209.85.216.170]:46397 "EHLO
        mail-qt0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1162120AbeBNSpW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Feb 2018 13:45:22 -0500
Received: by mail-qt0-f170.google.com with SMTP id u6so8926144qtg.13
        for <linux-scsi@vger.kernel.org>; Wed, 14 Feb 2018 10:45:21 -0800 (PST)
In-Reply-To: <yq11shoqpuy.fsf@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Lukas Herbolt <lherbolt@redhat.com>
Cc: linux-scsi@vger.kernel.org

On Tue, 2018-02-13 at 21:14 -0500, Martin K. Petersen wrote:
> Lukas,
> 
> > I like the idea to have an option to separate the memory area for
> > different LUNs, while keeping the current behavior as default.
> 
> As the name implies, scsi_debug is mostly a tool for debugging the
> SCSI
> stack.
> 
> If you care about storing data, why not simply use target in loopback
> mode?
> 

Hi Martin

I think what Lukas was really looking for is what I started out
wanting.
Individual devices that could be put into configurations such as md-
raid for testing and could be used with fault injection.

In the end I had to use 5 (LIO or physical) devices and 1 scsi_debug
device to reproduce an issue for md-raid.
Target loopback was an option too.

I have fault injection in qla2xxx tcm already but not in the target
core.

I guess it time i look into that now so will proceed with that.

Regards
Laurence
