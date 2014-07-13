From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH V3 0/7] Drivers: scsi: storvsc: Bug fixes and improvements
Date: Sun, 13 Jul 2014 18:37:40 +0000
Message-ID: <198e3f0daafa415d93fdad3e6c0c9433@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1405183684-23928-1-git-send-email-kys@microsoft.com>
 <20140713095102.GB19682@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20140713095102.GB19682@infradead.org>
Content-Language: en-US
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jasowang@redhat.com" <jasowang@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "ohering@suse.com" <ohering@suse.com>, "apw@canonical.com" <apw@canonical.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Sunday, July 13, 2014 2:51 AM
> To: KY Srinivasan
> Cc: jasowang@redhat.com; apw@canonical.com; linux-
> kernel@vger.kernel.org; devel@linuxdriverproject.org; ohering@suse.com;
> jbottomley@parallels.com; hch@infradead.org; linux-scsi@vger.kernel.org
> Subject: Re: [PATCH V3 0/7] Drivers: scsi: storvsc: Bug fixes and
> improvements
> 
> The series looks good to me, although I'll probably put the commit message
> for the timer patch into the comment for the eh_timed_out handler.

Do you want me to send the patch out with the additional comments. Would
you be checking these in.

K. Y
> 
> Can I get another set of reviews?  I've seen Olaf has put them into the SLES
> tree, so I'd expect he's done a review already?
