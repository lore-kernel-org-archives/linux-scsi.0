From: Andre Hedrick <andre@linux-ide.org>
Subject: Re: [PATCH / RFC] scsi_error handler update. (1/4)
Date: Tue, 18 Feb 2003 14:16:27 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.10.10302181352150.3880-100000@master.linux-ide.org>
References: <3E528DA9.1000209@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3E528DA9.1000209@splentec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>


Luben:

<Point 4 answered>
**********************
Date: Tue, 26 Mar 2002 15:31:41 -0500
From: Luben Tuikov <luben@splentec.com>
To: iSCSI <ips@ece.cmu.edu>, <other names deleted>
Subject: iSCSI: Login stage transition; T bit
**********************

I will give Eddy a call to confirm your point.

<Point 3 answered>

I know exactly what a portal, since I have already abstractived it away in
the current environment, I see no need to add such additional layering.
The current mid-layer handles it fine if you know how to map the issue
according to its rules.

I know exactly what an iSCSI TPGT is and the relation to the DOMAIN.

<Point 2 answered>

Making a target a collecion of LUs becomes a problem once you hit the
saturate the queue of the associated HBA's.  Since Linux associates the
queue depth to the HBA and not the actual device, other problems arrise.

HBA queue detpth == 255/256
HDA queue detpth == 31/32

HBA has 16 HDA's (for this example).

Artificially pooling to make two virtual HBA's of 8 HDA's each, while not
constraining the queue depth, will explode the midlayer.

Now assume an expanded model with N physical HBA's and load balancing the
queue issue becomes impossible.  So one needs to address it as another
issue.

<Point 1 answered>

OIC, maybe you should be more clear in your choice of terms.  Given the
answer to point 4 above is subject to your motivation.

Cheers,

Andre Hedrick
LAD Storage Consulting Group

