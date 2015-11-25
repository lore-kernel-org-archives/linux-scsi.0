From: Ching Huang <ching2048@areca.com.tw>
Subject: Re: [PATCH 0/2] arcmsr: support areca new adapter ARC1203
Date: Wed, 25 Nov 2015 10:45:02 +0800
Message-ID: <1448419502.4698.10.camel@Centos6.3-64>
References: <1448352055.12861.39.camel@Centos6.3-64>
	 <56547D23.1010100@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56547D23.1010100@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: hch@infradead.org, thenzl@redhat.com, jbottomley@parallels.com, dan.carpenter@oracle.com, agordeev@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hch@lst.de
List-Id: linux-scsi@vger.kernel.org

On Tue, 2015-11-24 at 16:07 +0100, Hannes Reinecke wrote:
> On 11/24/2015 09:00 AM, Ching Huang wrote:
> > From: Ching Huang <ching2048@areca.com.tw>
> > 
> > Patch 1 fixes getting wrong configuration data.
> > 
> > Pacth 2 adds codes to support new adapter ARC1203.
> > 
    Patch 3 changes driver version number.
> Please split off the driver version update into a separate patch and
> add it as the last patch in the series.
> Otherwise it'll be hard to keep track of which patch belongs to
> which version.
> Thanks.
> 
> Cheers,
> 
> Hannes
> 
OK. So I have patch 3 as above.
I will resend v2 all 3 patches later. 

Thanks, 
Ching
> 
