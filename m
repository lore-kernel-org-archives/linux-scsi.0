From: "Bryan Henderson" <hbryan@us.ibm.com>
Subject: Re: Inhibit auto-attach of scsi disks ?
Date: Thu, 3 Oct 2002 10:52:54 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF95813638.FCD7B92F-ON87256C47.005C28B5@boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-scsi@vger.kernel.org, Scott Merritt <Scsi@PragmaSoft.com>

>>I should be able to control whether Linux
>> considers there to be partitions on my disk or not 
>
>Why do you want to?  Linux always offers you the entire disk anyway.

Others have given arcane examples of where this is useful, but I am coming 
at it from a philosophical point of view.  It's great that Linux can 
magically detect and make available partitions on the disk, but some of us 
like our systems to work with as little magic as possible.  It makes the 
system easier to understand, easier to diagnose when it doesn't work, and 
more flexible.

It's clear to me that the partitions are conceptually a layer above basic 
disks, so I'd like to see the layers separable.

