From: Matthew Jacob <mjacob@feral.com>
Subject: Re: [PATCH] Ghost devices being reported with AIC7XXX version 6.2.6
Date: Thu, 31 Oct 2002 12:39:29 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.BSF.4.21.0210311236500.23076-100000@beppo>
References: <20021031203832.GG30047@redhat.com>
Reply-To: mjacob@feral.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021031203832.GG30047@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: "Justin T. Gibbs" <gibbs@scsiguy.com>, Mike Brown <mbrown@emc.com>, bferjul@emc.com, jkrasner@emc.com, conway_heather@emc.com, linux-scsi@vger.kernel.org


> And we recently added INQUIRY with the EVPD bit set and an EVPD page 0.  
> From the reports I've seen, I'm pretty sure it's causing a more than
> trivial number of devices to lock up on boot.  I suspect blindly pulling a
> REPORT_LUNS on SCSI-2 devices would likely cause similar problems.

That's less likely than the EVPD stuff which seems to make more devices
choke than not.

I would suggest the following for REPORT LUNS usage on SCSI-2 devices:

+ a config option (so it goes away in a year) to enable REPORT LUNS on
SCSI-2, or set an uppper SCSI-2 lun scan limit.

+ REPORT LUNS will only be used on SCSI-2 devices that are DIRECT ACCESS
(sorry, ATL && other tape and tape emulator folks)


