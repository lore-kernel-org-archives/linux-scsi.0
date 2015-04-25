From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH 1/1] scsi: storvsc: Set the SRB flags correctly when no
 data transfer is needed
Date: Sat, 25 Apr 2015 16:15:07 +0000
Message-ID: <BY2PR0301MB0711A25967BC191039F5BD44A0EB0@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1429918435-8353-1-git-send-email-kys@microsoft.com>
 <20150425070514.GP14154@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20150425070514.GP14154@mwanda>
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
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "jasowang@redhat.com" <jasowang@redhat.com>, "ohering@suse.com" <ohering@suse.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "apw@canonical.com" <apw@canonical.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> Sent: Saturday, April 25, 2015 12:05 AM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; ohering@suse.com;
> jbottomley@parallels.com; hch@infradead.org; linux-scsi@vger.kernel.org;
> apw@canonical.com; vkuznets@redhat.com; jasowang@redhat.com;
> stable@vger.kernel.org
> Subject: Re: [PATCH 1/1] scsi: storvsc: Set the SRB flags correctly when no
> data transfer is needed
> 
> On Fri, Apr 24, 2015 at 04:33:55PM -0700, K. Y. Srinivasan wrote:
> > Set the SRB flags correctly when there is no data transfer.
> >
> 
> What are the user visible effects of this bug?  We transfer bogus data?

No, we don't transfer any bogus data. However, some IHV drivers will
return an error on some valid commands because of these flags being set.

Regards,

K. Y
> 
> regards,
> dan carpenter
