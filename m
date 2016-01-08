From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: System "hangs" on kernels > v4.4-rc1 - mpt2sas problem?
Date: Fri, 08 Jan 2016 10:56:57 -0800
Message-ID: <1452279417.2297.5.camel@HansenPartnership.com>
References: <3908561D78D1C84285E8C5FCA982C28F39FA658E@ORSMSX114.amr.corp.intel.com>
	 <yq137u8iyue.fsf@sermon.lab.mkp.net>
	 <3908561D78D1C84285E8C5FCA982C28F39FA727F@ORSMSX114.amr.corp.intel.com>
	 <yq1r3hsf0bg.fsf@sermon.lab.mkp.net>
	 <3908561D78D1C84285E8C5FCA982C28F39FA73FD@ORSMSX114.amr.corp.intel.com>
	 <yq1io34ezoh.fsf@sermon.lab.mkp.net>
	 <3908561D78D1C84285E8C5FCA982C28F39FA77D9@ORSMSX114.amr.corp.intel.com>
	 <1452277927.2297.2.camel@HansenPartnership.com>
	 <3908561D78D1C84285E8C5FCA982C28F39FA7873@ORSMSX114.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F39FA7873@ORSMSX114.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Luck, Tony" <tony.luck@intel.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2016-01-08 at 18:42 +0000, Luck, Tony wrote:
> > We're not quite out of the woods yet: dracut should have seen this
> > automatically because of the module alias bindings.  Is your system
> > somehow unusual and you don't expect the initrd automatic module
> > selection to work?  If not, could you help us debug why it didn't?
> 
> I saw the same problem building a 4.4-rc* kernel on a RHEL7.2
> and SLES12-SP1 system.
> 
> My build process is in both cases is:
> $ tar xf linux-...
> $ cd linux...
> $ cp /boot/config-xyzzy .
> $ yes "" | make oldconfig
> $ make -j 100
> $ su
> # make -j 100 modules_install && make install
> 
> What sort of features of a system might be considered "unusual"?
> This looks a very simple system ... just one disk controller with two
> drive bays occupied.
> 
> Let me know if you'd like run any topology reporting commands.

No, the problem will lie in the initrd building part.  I know that with
debian mkinitramfs takes the -v option which will tell you what modules
it's selecting and why, but I'm not very familiar with enterprise
distributions; chances are whatever command you use to build the initrd
does take a -v.

James
