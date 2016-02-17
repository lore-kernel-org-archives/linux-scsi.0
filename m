From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: Re: [PATCH v2] [SCSI] dpt_i2o: use proper pci driver
Date: Wed, 17 Feb 2016 21:20:03 +0530
Message-ID: <56C496AB.2070200@gmail.com>
References: <1455711614-5185-1-git-send-email-sudipm.mukherjee@gmail.com> <20160217142732.6dcad24c@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160217142732.6dcad24c@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

On Wednesday 17 February 2016 07:57 PM, One Thousand Gnomes wrote:
> On Wed, 17 Feb 2016 17:50:14 +0530
> Sudip Mukherjee <sudipm.mukherjee@gmail.com> wrote:
>
>> This is a pci device but was not done in the usual way a pci driver =
is
>> done. Convert the driver into a proper pci driver.
>
> This looks completely wrong. Please read the I2O 1.5 specification
> document before playing with that code. You can't simply convert it t=
o a
> standard PCI driver as all the IOPs are supposed to be detected and t=
hen
> the correct initialization sequence executed across the set of IOPs. =
IOPs
> are allowed to talk to one another and the system table binds it all
> together.

Yes, thanks for letting me know about the spec. It is saying
"The host locates each IOP, adds it
to the system configuration table, and initializes the IOP=92s outbound=
=20
message queue. The host then
provides each IOP with a list of all IOPs and the physical location of=20
their inbound message queue."

>
> If you do hot plug then you need to follow the specification and do
> all the extra notifications. Unless you've got multiple FC909/FC920
> fibechannel cards or similar to test with I would just leave this wel=
l
> alone.

point noted.

> Your original simple patch is *MUCH* safer in this specific case.

The original patch is already having NACK from Johannes. So i better=20
leave this code here.

regards
sudip
