Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DC51C433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Apr 2021 23:56:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F69F61419
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Apr 2021 23:56:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbhD2X5b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Apr 2021 19:57:31 -0400
Received: from gateway31.websitewelcome.com ([192.185.143.51]:28160 "EHLO
        gateway31.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229557AbhD2X5a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 29 Apr 2021 19:57:30 -0400
X-Greylist: delayed 1446 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Apr 2021 19:57:30 EDT
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway31.websitewelcome.com (Postfix) with ESMTP id E238238103
        for <linux-scsi@vger.kernel.org>; Thu, 29 Apr 2021 18:32:34 -0500 (CDT)
Received: from just2098.justhost.com ([173.254.31.45])
        by cmsmtp with SMTP
        id cG94lhDuyMGeEcG94lvYtH; Thu, 29 Apr 2021 18:32:34 -0500
X-Authority-Reason: nr=8
Received: from 116-240-66-4.sta.dodo.net.au ([116.240.66.4]:32928 helo=[192.168.1.104])
        by just2098.justhost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <erwin@erwinvanlonden.net>)
        id 1lcG93-000Art-Fh; Thu, 29 Apr 2021 17:32:34 -0600
Message-ID: <d26cbf916bbff974cda28536b128129ea3a0f13b.camel@erwinvanlonden.net>
Subject: Re: [dm-devel] RFC: one more time: SCSI device identification
From:   Erwin van Londen <erwin@erwinvanlonden.net>
To:     Martin Wilck <martin.wilck@suse.com>,
        "hare@suse.de" <hare@suse.de>,
        "Ulrich.Windl@rz.uni-regensburg.de" 
        <Ulrich.Windl@rz.uni-regensburg.de>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc:     "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "dgilbert@interlog.com" <dgilbert@interlog.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "systemd-devel@lists.freedesktop.org" 
        <systemd-devel@lists.freedesktop.org>,
        Hannes Reinecke <hare@suse.com>, "hch@lst.de" <hch@lst.de>
In-Reply-To: <643e5f7eb3e2d48517a3288c07af001b30e22075.camel@suse.com>
References: <c524ce68d9a9582732db8350f8a1def461a1a847.camel@suse.com>
         <yq135w4cam3.fsf@ca-mkp.ca.oracle.com>
         <06489ea37311fe7bf73b27a41b5209ee4cca85fe.camel@suse.com>
         <yq1pmynt6f6.fsf@ca-mkp.ca.oracle.com>
         <685c40341d2ddef2fe5a54dd656d10104b0c1bfa.camel@suse.com>
         <yq1im4dre94.fsf@ca-mkp.ca.oracle.com>
         <e3184501cbf23ab0ae94d664725e72b693c64ba9.camel@suse.com>
         <6086A0B2020000A100040BBE@gwsmtp.uni-regensburg.de>
         <59dc346de26997a6b8e3ae3d86d84ada60b3d26b.camel@suse.com>
         <b5f288fb43bc79e0206794a901aef5b1761813de.camel@erwinvanlonden.net>
         <15e1a6a493f55051eab844bab2a107f783dc27ee.camel@suse.com>
         <2a6903e4-ff2b-67d5-e772-6971db8448fb@suse.de>
         <ff5b30ca02ecfad00097ad5f8b84d053514fb61c.camel@erwinvanlonden.net>
         <643e5f7eb3e2d48517a3288c07af001b30e22075.camel@suse.com>
Content-Type: text/plain; charset="UTF-8"
Date:   Fri, 30 Apr 2021 00:47:57 +1000
MIME-Version: 1.0
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - just2098.justhost.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - erwinvanlonden.net
X-BWhitelist: no
X-Source-IP: 116.240.66.4
X-Source-L: No
X-Exim-ID: 1lcG93-000Art-Fh
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 116-240-66-4.sta.dodo.net.au ([192.168.1.104]) [116.240.66.4]:32928
X-Source-Auth: erwin@erwinvanlonden.net
X-Email-Count: 6
X-Source-Cap: aGl0YWNoaTE7aGl0YWNoaTE7anVzdDIwOTguanVzdGhvc3QuY29t
X-Local-Domain: yes
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On Wed, 2021-04-28 at 06:34 +0000, Martin Wilck wrote:
> On Wed, 2021-04-28 at 11:01 +1000, Erwin van Londen wrote:
> > 
> > The way out of this is to chuck the array in the bin. As I mentioned
> > in one of my other emails when a scenario happens as you described
> > above and the array does not inform the initiator it goes against the
> > SAM-5 standard.
> > 
> > That standard shows:
> > 5.14 Unit attention conditions
> > 5.14.1 Unit attention conditions that are not coalesced
> > Each logical unit shall establish a unit attention condition whenever
> > one of the following events occurs:
> >         a) a power on (see 6.3.1), hard reset (see 6.3.2), logical
> > unit reset (see 6.3.3), I_T nexus loss (see 6.3.4), or power loss
> > expected (see 6.3.5) occurs;
> >         b) commands received on this I_T nexus have been cleared by
> > a command or a task management function associated with another I_T
> > nexus and the TAS bit was set to zero in the Control mode page
> > associated with this I_T nexus (see 5.6);
> >         c) the portion of the logical unit inventory that consists
> > of administrative logical units and hierarchical logical units has
> > been changed (see 4.6.18.1); or
> >         d) any other event requiring the attention of the SCSI
> > initiator device.
> > 
> > Especially the I_T nexus loss under a is an important trigger.
> > 
> > ---
> > 6.3.4 I_T nexus loss
> > An I_T nexus loss is a SCSI device condition resulting from:
> > 
> >  a) a hard reset condition (see 6.3.2);
> >  b) an I_T nexus loss event (e.g., logout) indicated by a Nexus Loss
> > event notification (see 6.4);
> >  c) indication that an I_T NEXUS RESET task management request (see
> > 7.6) has been processed; or
> >  d) an indication that a REMOVE I_T NEXUS command (see SPC-4) has
> > been processed.
> > An I_T nexus loss event is an indication from the SCSI transport
> > protocol to the SAL that an I_T nexus no
> > longer exists. SCSI transport protocols may define I_T nexus loss
> > events.
> > 
> > Each SCSI transport protocol standard that defines I_T nexus loss
> > events should specify when those events
> > result in the delivery of a Nexus Loss event notification to the SAL.
> > 
> > The I_T nexus loss condition applies to both SCSI initiator devices
> > and SCSI target devices.
> > 
> > If a SCSI target port detects an I_T nexus loss, then a Nexus Loss
> > event notification shall be delivered to
> > each logical unit to which the I_T nexus has access.
> > 
> > In response to an I_T nexus loss condition a logical unit shall take
> > the following actions:
> > a) abort all commands received on the I_T nexus as described in 5.6;
> > b) abort all background third-party copy operations (see SPC-4) that
> > are using the I_T nexus;
> > c) terminate all task management functions received on the I_T nexus;
> > d) clear all ACA conditions (see 5.9.5) associated with the I_T
> > nexus;
> > e) establish a unit attention condition for the SCSI initiator port
> > associated with the I_T nexus (see 5.14
> > and 6.2); and
> > f) perform any additional functions required by the applicable
> > command standards.
> > ---
> > 
> > This does also mean that any underlying transport protocol issues
> > like on FC or TCP for iSCSI will very often trigger aborted commands
> > or UA's as well which will be picked up by the kernel/respected
> > drivers.
> 
> Thanks a lot. I'm not quite certain which of these paragraphs would
> apply to the situation I had in mind (administrator remapping an
> existing LUN on a storage array to a different volume). That scenario
> wouldn't necessarily involve transport-level errors, or an I_T nexus
> loss. 5.14.1 c) or d) might apply, is that what you meant?

I was indeed mostly referring to:

 	c) the portion of the logical unit inventory that consists
 of administrative logical units and hierarchical logical units has
 been changed (see 4.6.18.1); or
 	d) any other event requiring the attention of the SCSI
 initiator device.

The IT nexus status itself might not have changed but if an abstraction
layer representing a totally different set of data that would most
definitely fall under d. I think swapping between a volume and one of
its snapshots also falls under this 


> 
> Regards
> Martin
> 

