From: Sitsofe Wheeler <sitsofe@gmail.com>
Subject: Re: BLKZEROOUT not zeroing md dev on VMDK
Date: Wed, 15 Jun 2016 22:33:21 +0100
Message-ID: <20160615213320.GA9527@sucs.org>
References: <20160518223616.GA409@sucs.org>
 <20160527041824.GC9418@birch.djwong.org>
 <CALjAwxgkgPZdXFkOuD-7Dsbxf9oVEGuXTDLnyqu8rTrJio_4mA@mail.gmail.com>
 <CAGnHSEn0ntEw_dwFNqG6CdgwcpHzQie88jgA21uioKhBbcByTg@mail.gmail.com>
 <CALjAwxgdr1zSgZZzNA9BQ8Ta+UuutJ6iuBnqZfmV-BTCDL2PbA@mail.gmail.com>
 <1466014718999.6976@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1466014718999.6976@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arvind Kumar <arvindkumar@vmware.com>
Cc: Tom Yan <tom.ty89@gmail.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@kernel.dk>, VMware PV-Drivers <pv-drivers@vmware.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Petr Vandrovec <petr@vmware.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jun 15, 2016 at 06:17:37PM +0000, Arvind Kumar wrote:
> It is possibly some race. We saw a WRITE SAME related issue in past
> for which Petr sent out a patch but looks like the patch didn't make
> it. :(
> 
> https://groups.google.com/forum/#!topic/linux.kernel/1WGDSlyY0y0

Indeed - the investigation you folks did is linked to within the
upstream Bugzilla bug (see
https://bugzilla.kernel.org/show_bug.cgi?id=118581#c2 ). Hopefully this
issue will be resolved but there's still some debate over on
http://thread.gmane.org/gmane.linux.kernel/2236800 . The problem is that
it is causing real problems in stable kernels (data not being correctly
zero'd) today...

-- 
Sitsofe | http://sucs.org/~sits/
