From: KY Srinivasan <kys@microsoft.com>
Subject: RE: Drivers: scsi
Date: Sun, 4 Nov 2012 15:26:31 +0000
Message-ID: <426367E2313C2449837CD2DE46E7EAF930DF9113@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <1351960806-16240-1-git-send-email-kys@microsoft.com>
 <1352021949.2427.19.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces@linuxdriverproject.org>
In-Reply-To: <1352021949.2427.19.camel@dabdike.int.hansenpartnership.com>
Content-Language: en-US
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/devel>,
 <mailto:devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/devel/>
List-Post: <mailto:devel@linuxdriverproject.org>
List-Help: <mailto:devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/devel>,
 <mailto:devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: devel-bounces@linuxdriverproject.org
Sender: "devel" <devel-bounces@linuxdriverproject.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "ohering@suse.com" <ohering@suse.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]
> Sent: Sunday, November 04, 2012 4:39 AM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; ohering@suse.com; hch@infradead.org; linux-
> scsi@vger.kernel.org
> Subject: Re: Drivers: scsi
> 
> On Sat, 2012-11-03 at 09:40 -0700, K. Y. Srinivasan wrote:
> > Do we currently support dynamic re-sizing of LUNs. Hyper-V can
> > notify capacity change via sense data and I was wondering if this
> > is handled in the generic scsi code.
> 
> Depends what you mean by "dynamic".  Experience shows that most users
> really don't want all this to happen without manual intervention
> (particularly on shrink).  However, we have the mechanics in place.
> Just send ASC/Q 2A/09 and it can get vectored up to LVM which resizes
> the volume and can be scripted automatically to resize the filesystem.
> 
> hypervisor people tend to have problems with scripting, so there are
> some hacks that do this outside of the normal event system ... see for
> example virtio_scsi.c

Thanks for the prompt response.

Regards,

K. Y
