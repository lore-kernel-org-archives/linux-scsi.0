From: "Martin K. Petersen" <mkp@mkp.net>
Subject: Re: ANNOUNCE: saftemon - SCSI Enclosure monitor for linux
Date: 18 Apr 2002 00:04:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <yq1elhdwt3i.fsf@austin.mkp.net>
References: <71714C04806CD51193520090272892170452B66C@ausxmrr502.us.dell.com>
	<3CBE1D51.9050300@metaparadigm.com>
	<3CBE3B56.1020408@metaparadigm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3CBE3B56.1020408@metaparadigm.com>
List-Id: linux-scsi@vger.kernel.org
To: Michael Clark <michael@metaparadigm.com>
Cc: Matt_Domsch@Dell.com, mjacob@feral.com, linux-scsi@vger.kernel.org

>>>>> "Michael" == Michael Clark <michael@metaparadigm.com> writes:

Michael> The SES command set is supposedly documented in the SFF-8067
Michael> specification developed by an X3 committee. I assume is
Michael> different to SAF-TE and have removed the reference to it in
Michael> the readme.

Yes.  SES is the successor to SAF-TE.

It's different in the sense that there's no SAF-TE processor device
visible on the bus.  Instead devices on an SES-capable bus will have
EnvServ set in the inquiry page.

I have some sample code kicking around, if you're interested.  Also,
the SES specs are official T10 ones (unlike SAF-TE).  You can download
them off t10.org.

-- 
Martin K. Petersen, Principal Linux Consultant, Linuxcare, Inc.
mkp@linuxcare.com, http://www.linuxcare.com/
SGI XFS for Linux Developer, http://oss.sgi.com/projects/xfs/

