From: Hannes Reinecke <hare@suse.de>
Subject: Re: [dm-devel] [LSF/MM ATTEND][LSF/MM TOPIC] Multipath redesign
Date: Wed, 13 Jan 2016 12:17:27 +0100
Message-ID: <56963247.2000800@suse.de>
References: <56961493.5010901@suse.de>
 <20160113110822.GC452@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47516 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754907AbcAMLRa (ORCPT <rfc822;Linux-scsi@vger.kernel.org>);
	Wed, 13 Jan 2016 06:17:30 -0500
In-Reply-To: <20160113110822.GC452@agk-dp.fab.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, device-mapper development <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <Linux-scsi@vger.kernel.org>, Junichi Nomura <j-nomura@ce.jp.nec.com>

On 01/13/2016 12:08 PM, Alasdair G Kergon wrote:
> On Wed, Jan 13, 2016 at 10:10:43AM +0100, Hannes Reinecke wrote:
>> The overall idea is to break up the centralized multipath handling i=
n
>> device-mapper (and multipath-tools) and delegate to the appropriate
>> sub-systems.
>>
>> Individually the plan is:
>
> Could we start to drill down into each of these and categorise them i=
n
> terms of which parts of the stack are involved in the proposed change
> and prioritise them in terms of likely amount of work and
> cost/benefit/risk?  Some of them probably need some prototyping and
> experimentation.
>
Sure.
That's why I proposed it as a discussion topic :-)

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
