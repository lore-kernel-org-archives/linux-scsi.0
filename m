From: "Nicholas Berry" <nikberry@med.umich.edu>
Subject: Re: Ultra320
Date: Fri, 25 Oct 2002 09:14:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <sdb90b8a.001@mail-01.med.umich.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: braver@pobox.com
Cc: linux-scsi@vger.kernel.org


>>> Alexy Khrabrov <braver@pobox.com> 10/25/02 08:52AM >>>
> So, is this obvious to others/unknown/off-topic/all of the above?  :-)  A.K.

>On Wed, Oct 23, 2002 at 12:04:15PM -0400, Alexy Khrabrov wrote:
>> 
>> If I get an Ultra320 card, will existing hard drives work 
>> at 320, or the hard drive itself should be new and aware?
>> Will current Linux drivers support Ultra320?
>> 
>> -- 
>> Cheers,
>> Alexy Khrabrov :: www.setup.org :: Age Quod Agis

Well, all of the above :)

But anyway, for Ultra 320 you'll need HBA and drives that support it. They'll negotiate the fastest
they can both do. You can have some 320, some 160 etc. mixed on the same bus, that's fine.

Now as to whether the Linux drivers support it, that's a driver-by-driver thing. Pick an Ultra 320 card,
and see if there's a driver for it.

Nik



