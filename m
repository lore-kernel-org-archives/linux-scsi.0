From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: limit on size of a SCSI drive?
Date: 27 Mar 2003 17:25:45 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1048785943.3228.13.camel@dhcp22.swansea.linux.org.uk>
References: <1048785293.26909.49.camel@frodo.bio.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1048785293.26909.49.camel@frodo.bio.sunysb.edu>
List-Id: linux-scsi@vger.kernel.org
To: Viktor Hornak <hornak@csb.sunysb.edu>
Cc: linux-scsi@vger.kernel.org

On Thu, 2003-03-27 at 17:14, Viktor Hornak wrote:
> hold up to 8 IDE disks. The UltraTrak presents itself as a single SCSI
> drive. With the disks we are planning to buy, the size of this 'fake'
> SCSI drive would be about 2.1TB! Now, my question is if SCSI module or

The limit is 1 or 2Tb depending upon what you are doing (normally 2Tb).
The same is true per volume for other setups too, so if for example
you throw the same disks on a 3ware IDE raid card you also have to split
it up into multiple 'disks'

2.5.x breaks this barrier

