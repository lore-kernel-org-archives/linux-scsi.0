From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 24/24] osst: add a SPDX tag to osst.c
Date: Fri, 3 May 2019 10:05:03 +0200
Message-ID: <c9a58611-13e2-8e13-b573-b504032c017c@suse.de>
References: <20190501161417.32592-1-hch@lst.de>
 <20190501161417.32592-25-hch@lst.de>
 <70277444-5b5b-6e3c-5af3-c658a841b144@suse.de> <20190502125312.GA2560@lst.de>
 <10a8c8f5-879c-685f-f43c-d5af678b2187@suse.de>
 <CAKnBiiaSyW27tCqU4i6zStF3AoLPcndSL2gjz1b17LdoFddiiw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKnBiiaSyW27tCqU4i6zStF3AoLPcndSL2gjz1b17LdoFddiiw@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Willem Riede <osst@riede.org>
Cc: Christoph Hellwig <hch@lst.de>, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>, Doug Gilbert <dgilbert@interlog.com>, Jens Axboe <axboe@kernel.dk>, =?UTF-8?Q?Kai_M=c3=a4kisara?= <Kai.Makisara@kolumbus.fi>, linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, osst-users@lists.sourceforge.net, linux-kernel@vger.kernel.org, Chriosstoph Hellwig <hch@losst.de>
List-Id: linux-scsi@vger.kernel.org

On 5/2/19 9:55 PM, Willem Riede wrote:
> On Thu, May 2, 2019 at 7:19 AM Hannes Reinecke <hare@suse.de 
> <mailto:hare@suse.de>> wrote:
> 
>     On 5/2/19 2:53 PM, Christoph Hellwig wrote:
>      > On Thu, May 02, 2019 at 08:06:38AM +0200, Hannes Reinecke wrote:
>      >> On 5/1/19 6:14 PM, Christoph Hellwig wrote:
>      >>> osst.c is the only osst file missing licensing information.  Add a
>      >>> GPLv2 tag for the default kernel license.
>      >>>
>      >>> Signed-off-by: Chriosstoph Hellwig <hch@losst.de
>     <mailto:hch@losst.de>>
>      >
>      > FYI, my s/st/osst/ on the commit message message up my signoff, this
>      > should be:
>      >
>      > Signed-off-by: Christoph Hellwig <hch@lst.de <mailto:hch@lst.de>>
>      >
>     Maybe it's time to kill osst.c for good ...
> 
> 
> Yes. I've been thinking about doing just that. The devices it supports 
> are now thoroughly obsolete. The manufacturer has gone out of business. 
> All my test drives have broken down over time, so I can't even test any 
> changes any more.
> 
Just when I thought to reach out to you :-)

Thing is, we've done numerous changes to the 'st' driver in the course 
of the years, most of which seem to have avoided osst :-(

So what's your suggestion here?
Just drop it completely?
Or can we somehow fold the OnStream-specific things back into st.c?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
