From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH 1/2] scsi: scsi_transport_fc: Provide a lightweight option
 for Virtual FC Hosts.
Date: Fri, 27 Jan 2017 15:45:26 +0000
Message-ID: <DM5PR03MB249022A752750BB1C0620BF6A0760@DM5PR03MB2490.namprd03.prod.outlook.com>
References: <1484771338-8903-1-git-send-email-cavery@redhat.com>
 <1484771338-8903-2-git-send-email-cavery@redhat.com>
 <20170119151155.GA28462@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20170119151155.GA28462@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>, Cathy Avery <cavery@redhat.com>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, Haiyang Zhang <haiyangz@microsoft.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Thursday, January 19, 2017 7:12 AM
> To: Cathy Avery <cavery@redhat.com>
> Cc: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; jejb@linux.vnet.ibm.com;
> martin.petersen@oracle.com; devel@linuxdriverproject.org; linux-
> kernel@vger.kernel.org; linux-scsi@vger.kernel.org
> Subject: Re: [PATCH 1/2] scsi: scsi_transport_fc: Provide a lightweight option
> for Virtual FC Hosts.
> 
> On Wed, Jan 18, 2017 at 03:28:57PM -0500, Cathy Avery wrote:
> > The patch provides a means to offer a lightweight option to the
> > current FC transport class. The new option is selected by a
> > driver when it indicates it wants the lightweight
> > transport via fc_function_template.
> 
> This need some really good documentation in the code and changelog
> what "lightweight" means.  It's a pretty horrible term, btw.

This was a concept that James proposed almost a year ago. I agree, we need to document this
better.

K. Y
