From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [GIT PATCH v4 0/2] libsas: eh reworks (ata-eh vs discovery,
 races, ...)
Date: Tue, 10 Jan 2012 12:18:06 -0800
Message-ID: <CABE8wwuBN45f2s-bcW3R=5VE1V3svtcrp93-9LW5zZ6VtZFqmQ@mail.gmail.com>
References: <20120110073647.4563.7504.stgit@localhost6.localdomain6>
	<1326223752.3264.43.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:30300 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754842Ab2AJUSJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Jan 2012 15:18:09 -0500
In-Reply-To: <1326223752.3264.43.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, jack_wang@usish.com

On Tue, Jan 10, 2012 at 11:29 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Mon, 2012-01-09 at 23:38 -0800, Dan Williams wrote:
>> The latest version of the patch kit is available here:
>>
>> =A0 git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git libs=
as-eh-reworks-v4
>>
>> Changes since v3: http://marc.info/?l=3Dlinux-scsi&m=3D1325814552147=
89&w=3D2
>
> Just to check I'm not lost here. I think this is currently the only
> mergeable set of patches you have because you're reworking patches in
> all your other series and will repost ... is this correct?

There are two mergeable topics in isci.git:
libsas-eh-reworks-v4: mergeable
devel: mergeable, posted as "[GIT PATCH v2 00/15] isci update for 3.3
(part1)" [1].  This contains all the general updates to the driver
that were independent of the libsas churn.  It was rebased to
incorporate Ben's firmware removal patch, but is otherwise idle and
ready to merge.

--
Dan

http://marc.info/?l=3Dlinux-scsi&m=3D132581499114886&w=3D2
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
