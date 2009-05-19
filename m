From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 03/13] block: Move queue limits to an embedded struct
Date: Tue, 19 May 2009 12:46:00 -0400
Message-ID: <yq1bpppghx3.fsf@sermon.lab.mkp.net>
References: <1242362435-11953-1-git-send-email-martin.petersen@oracle.com>
	<1242362435-11953-4-git-send-email-martin.petersen@oracle.com>
	<20090518185007.GA839@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20090518185007.GA839@redhat.com> (Mike Snitzer's message of
	"Mon, 18 May 2009 14:50:08 -0400")
Sender: linux-ide-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: jens.axboe@oracle.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, agk@redhat.com
List-Id: linux-scsi@vger.kernel.org

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

Mike> Given DM motivated this change, any reason you held off including
Mike> the associated DM changes (in a separate patch in the series)?
Mike> Your initial DM patch looked reasonable.

It sounded like you and Alasdair had a plan so I left it out.

If you guys are happy with what I did I'm happy to push it.


Mike> Are you looking for such DM changes to be submitted through
Mike> Alasdair's tree _after_ your changes go upstream through Jens'
Mike> tree?

Yeah, it'll have to be a multistage merge.  Block will need to hit
first, then SCSI, DM and MD.  And after those are in we can nuke the old
stacking function.

-- 
Martin K. Petersen	Oracle Linux Engineering
