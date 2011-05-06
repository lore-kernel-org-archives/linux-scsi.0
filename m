From: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [patch v3 2/3] block: hold queue if flush is running for  non-queueable
 flush drive
Date: Fri, 6 May 2011 11:28:54 -0600
Message-ID: <4DC42FD6.8010508@fusionio.com>
References: <20110505015932.306763905@sli10-conroe.sh.intel.com> <20110505020417.817084678@sli10-conroe.sh.intel.com> <20110505083853.GC30950@htj.dyndns.org> <1304656325.3828.22.camel@sli10-conroe> <20110506065347.GA8824@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110506065347.GA8824@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Shaohua Li <shaohua.li@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "jgarzik@pobox.com" <jgarzik@pobox.com>, "djwong@us.ibm.com" <djwong@us.ibm.com>, "sshtylyov@mvista.com" <sshtylyov@mvista.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "ricwheeler@gmail.com" <ricwheeler@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On 2011-05-06 00:53, Tejun Heo wrote:
> Jens, can you please queue this for the next merge window?

Yep I will, I'll mark it as a backport as well.

-- 
Jens Axboe
