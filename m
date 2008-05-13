From: "Love, Robert W" <robert.w.love@intel.com>
Subject: RE: Open-FCoE Re-architecture Status
Date: Tue, 13 May 2008 08:39:03 -0700
Message-ID: <10A7D0016239E24092DEF05CCC582E43039F5FE1__22346.6189265766$1210693527$gmane$org@fmsmsx411.amr.corp.intel.com>
References: <10A7D0016239E24092DEF05CCC582E43039F5DA0@fmsmsx411.amr.corp.intel.com> <e2e108260805122258t7f284f27p11bad38eb1efa848@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:51218 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756020AbYEMPjj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 May 2008 11:39:39 -0400
Content-class: urn:content-classes:message
In-Reply-To: <e2e108260805122258t7f284f27p11bad38eb1efa848@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: linux-scsi@vger.kernel.org, devel@open-fcoe.org

>On Tue, May 13, 2008 at 2:47 AM, Love, Robert W
<robert.w.love@intel.com>
>wrote:
>> After a lot of planning and designing we've started to
>> reorganize the Open-FCoE kernel code.
>
>Hello Robert,
>
>Sorry if I'm asking something trivial, but does this apply to the FCoE
>initiator implementation or to the FCoE target implementation ?

The focus is on the initiator, but it may have some impact on the
target. My plan is to get the initiator an acceptable architecture and
then see if we can fit the target in. 

If you're unaware, we have a target implementation that is based on a
2.6.23 tree on our website. Unfortunately, it's not getting any
attention right now. Tomo also ported some of our code to userspace, but
I believe that effort is relatively untested. So, after the initiator
work is done, and time permitting, I'd like to revisit the target and
see if we can either get the userspace port going or add some hooks into
the initiator for an out-of-kernel target.

If anyone has good ideas I'm all ears, we're just dedicated to the
initiator for the time being.
