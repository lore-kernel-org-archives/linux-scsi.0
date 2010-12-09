From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 2/9] scsi: megaraid_sas - Driver only report tape
 drive, JBOD and logic drives
Date: Thu, 09 Dec 2010 11:07:21 -0600
Message-ID: <1291914441.3002.209.camel@mulgrave.site>
References: <4B6A08C587958942AA3002690DD4F8C3D0804533@cosmail02.lsi.com>
	 <4B6A08C587958942AA3002690DD4F8C3DBD67F68@cosmail02.lsi.com>
	 <4B6A08C587958942AA3002690DD4F8C30106A961BD@cosmail02.lsi.com>
	 <4B6A08C587958942AA3002690DD4F8C30106A961D6@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C30106A961D6@cosmail02.lsi.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'akpm@osdl.org'" <akpm@osdl.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "Daftardar, Jayant" <Jayant.Daftardar@lsi.com>, Tomas Henzl <thenzl@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2010-11-19 at 09:53 -0700, Yang, Bo wrote:
> Driver only report tape drive, JBOD and logic drives to OS

Could you explain the point of this further?  As far as I can see, it
would prevent the driver from reporting enclosures, which it is
currently doing.

James
