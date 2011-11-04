From: "Luck, Tony" <tony.luck@intel.com>
Subject: RE: scsi: killing requests for dead queue
Date: Fri, 4 Nov 2011 11:07:16 -0700
Message-ID: <987664A83D2D224EAE907B061CE93D5301FBD0FDFE@orsmsx505.amr.corp.intel.com>
References: <4eb3064c133909be1c@agluck-desktop.sc.intel.com>
 <201111041838.46062.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <201111041838.46062.bvanassche@acm.org>
Content-Language: en-US
Sender: linux-next-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, James Bottomley <JBottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org

> Commit 3308511 causes the SCSI queue cleanup code to be invoked
> for every killed queue. Since the SCSI scanning code can create
> and destroy SCSI queues repeatedly while probing LUNs, the
> following message can be printed several times during boot:
>
>    scsi: killing requests for dead queue

Does this message show up in some other situation (like when
a device has failed?). Would you actually want to see these
messages then?  If so, demoting them to debug sounds like
the wrong thing to do.

Would it be better to clean things up when destroying queues
during LUN probes?

-Tony

[apologies if these questions are na=EFve - scsi is all a black
box to me]
