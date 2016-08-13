From: Tejun Heo <tj@kernel.org>
Subject: Re: Time to make dynamically allocated devt the default for scsi
 disks?
Date: Sat, 13 Aug 2016 08:13:26 -0400
Message-ID: <20160813121326.GQ2695@mtj.duckdns.org>
References: <CAPcyv4jK8W52ss2FhJDa=95B_1q8Szv4AmH0f7p_jzyfEXv0Ag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPcyv4jK8W52ss2FhJDa=95B_1q8Szv4AmH0f7p_jzyfEXv0Ag@mail.gmail.com>
Sender: linux-block-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-block@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@fb.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Dave Hansen <dave.hansen@intel.com>, Jej B <James.Bottomley@hansenpartnership.com>
List-Id: linux-scsi@vger.kernel.org

Hello, Dan.

On Fri, Aug 12, 2016 at 02:29:30PM -0700, Dan Williams wrote:
> Before spending effort trying to flush the destruction of old bdi
> instances before new ones are registered, is it rather time to
> complete the conversion of sd to only use dynamically allocated devt?

I think that probably would be too disruptive to userland, both
programs and humans, that has been seeing the 8:N numbers forever now.
I haven't been following this particular issue but in general I think
we should switch to the regular "a depdendee object is pinned till all
the dependents are gone" pattern.

Thanks.

-- 
tejun
