From: Les Niles <lniles@Narus.com>
Subject: RE: ANNOUNCE: saftemon - SCSI Enclosure monitor for linux
Date: Wed, 17 Apr 2002 09:21:27 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <580E532D9F7A9B4BAE8A130848E0DDA701E6D9DA@franklin.narus.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: 'Michael Clark' <michael@metaparadigm.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

A README.install would be useful:

On a stock RH7.2 system, after a ./configure, make all, and 
make install, the /var/run/saftemon and /var/log/saftemon 
directories ended up with permissions 0755, user root and group 
root.  This caused saftemon to die because it couldn't open the 
pid file in /var/run/saftemon after setuid(daemon).  I changed 
the ownership of those directories to daemon and now it seems 
to work.  (The saftemon startup script did not get installed in 
/etc/rc.d/init.d; I don't know if this is intentional.)  Nice!  
This is all on a PowerEdge 6450. 

It also does the right thing on a Tyan SCSI motherboard: "No 
SAF-TE devices present"

  -les

> -----Original Message-----
> From: Michael Clark [mailto:michael@metaparadigm.com]
> Sent: Wednesday, April 17, 2002 4:01 AM
> To: linux-scsi@vger.kernel.org
> Subject: ANNOUNCE: saftemon - SCSI Enclosure monitor for linux
> 
> 
> saftemon - SCSI Enclosure monitor for SAFTE enclosures
> 
>    http://gort.metaparadigm.com/saftemon/
> 
> saftemon reads disk enclosure status information from SAF-TE
> capable enclosures (SCSI Accessible Fault Tolerant Enclosures).
> SAF-TE is a component of SES (SCSI Enclosure Services) which
> is common on most SCSI disk enclosures these days. saftemon
> can monitor multiple SAF-TE devices and will automatically probe
> and detect them.
