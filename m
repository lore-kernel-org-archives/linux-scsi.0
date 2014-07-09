From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH 3/8] Drivers: scsi: storvsc: Fix a bug in handling VMBUS
 protocol version
Date: Wed, 9 Jul 2014 20:01:30 +0000
Message-ID: <081524cbbab044ae842c9ed3ed1cc916@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1404866789-26910-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-3-git-send-email-kys@microsoft.com>
 <20140709084154.GC6012@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20140709084154.GC6012@infradead.org>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "ohering@suse.com" <ohering@suse.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "jasowang@redhat.com" <jasowang@redhat.com>, "apw@canonical.com" <apw@canonical.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Wednesday, July 9, 2014 1:42 AM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> ohering@suse.com; jbottomley@parallels.com; jasowang@redhat.com;
> apw@canonical.com; linux-scsi@vger.kernel.org; stable@vger.kernel.org
> Subject: Re: [PATCH 3/8] Drivers: scsi: storvsc: Fix a bug in handling VMBUS
> protocol version
> 
> > +	if ((vmbus_proto_version == VERSION_WS2008) ||
> > +	     (vmbus_proto_version == VERSION_WIN7)) {
> 
> This has superflous braces and doesn't use proper Linux indentation.
> 
> But I think simply using a switch here might be cleaner anyway.
I will do as you have suggested.

K. Y
