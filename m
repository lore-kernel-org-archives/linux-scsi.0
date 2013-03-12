From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 12/18] driver: scsi: remove cast for kmalloc/kzalloc
 return value
Date: Tue, 12 Mar 2013 09:27:49 +0000
Message-ID: <1363080469.2401.26.camel@dabdike.int.hansenpartnership.com>
References: <513EB23D.7020303@cn.fujitsu.com>
	 <513EBC2F.6030601@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <513EBC2F.6030601@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2013-03-12 at 13:25 +0800, Zhang Yanfei wrote:
> remove cast for kmalloc/kzalloc return value.

I've got to ask why?  Just because void * can be assigned to any pointer
doesn't mean we should religiously eliminate all casts of void *.  If
the driver writer believes there's value making sure of the pointer
type, I'm happy to keep the cast.

James
