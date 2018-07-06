From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 4/4] scsi: ncr53c8xx: remove ScsiResult macro
Date: Fri, 6 Jul 2018 10:09:39 +0200
Message-ID: <20180706080939.iotmgb24f6iaawkp@linux-x5ow.site>
References: <20180705110140.19545-1-jthumshirn@suse.de>
 <20180705110140.19545-5-jthumshirn@suse.de>
 <a4a799f62ffa873fc3a7e23a5a46dafc8805b984.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <a4a799f62ffa873fc3a7e23a5a46dafc8805b984.camel@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 05, 2018 at 05:04:05PM +0000, Bart Van Assche wrote:
> On Thu, 2018-07-05 at 13:01 +0200, Johannes Thumshirn wrote:
> > -		cmd->result = ScsiResult(DID_OK, S_CHECK_COND);
> > +		cmd->result = DID_OK << 16 | S_CHECK_COND;
> 
> Since DID_OK == 0, do we really need "DID_OK << 16 |" here?

Please see my answers to the other patches on this.

Thanks,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
