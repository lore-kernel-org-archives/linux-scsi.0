From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH v2] [hv] storvsc: Payload buffer incorrectly sized for 32
 bit kernels.
Date: Wed, 30 Nov 2016 06:17:26 +0000
Message-ID: <DM5PR03MB249079E798A20B5833D60ADCA08C0@DM5PR03MB2490.namprd03.prod.outlook.com>
References: <1479908793-19872-1-git-send-email-cavery@redhat.com>
 <yq11sxunrzp.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <yq11sxunrzp.fsf@sermon.lab.mkp.net>
Content-Language: en-US
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Cathy Avery <cavery@redhat.com>
Cc: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, Haiyang Zhang <haiyangz@microsoft.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
> Sent: Tuesday, November 29, 2016 8:58 AM
> To: Cathy Avery <cavery@redhat.com>
> Cc: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; jejb@linux.vnet.ibm.com;
> martin.petersen@oracle.com; devel@linuxdriverproject.org; linux-
> kernel@vger.kernel.org; linux-scsi@vger.kernel.org
> Subject: Re: [PATCH v2] [hv] storvsc: Payload buffer incorrectly sized for 32
> bit kernels.
> 
> >>>>> "Cathy" == Cathy Avery <cavery@redhat.com> writes:
> 
> Cathy> On a 32 bit kernel sizeof(void *) is not 64 bits as hv_mpb_array
> Cathy> requires. Also the buffer needs to be cleared or the upper bytes
> Cathy> will contain junk.
> 
> K.Y.: Please review!

Done.

K. Y
> 
> --
> Martin K. Petersen	Oracle Linux Engineering
