From: "shankar krishna" <kshan01@hotmail.com>
Subject: building SCSI CDB over FC
Date: Thu, 07 Nov 2002 19:44:24 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <F393oHMwVN7miR9Odut000000b9@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I am trying to send SCSI CDB over Fibre channel HBA.

Using IBM FC disk drive and qlogic HBA(QLA2300).

I want to build my own CDB (not with 'write' cmd which
sends an "ex write" to target) - eventually to build some
vendor specific CDBs!

Can anybody help me in this?

Rgds,
-Shankar.
PS: I am using FC analyser(FCacccess) inbetween Drive and HBA to
see the frames and their contents. If I do a "write"
of my own CDB, it sends it as data not as a command!!




_________________________________________________________________
MSN 8 helps eliminate e-mail viruses. Get 2 months FREE*. 
http://join.msn.com/?page=features/virus

