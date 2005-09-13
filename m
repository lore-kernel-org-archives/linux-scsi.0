From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH 2.6.13 5/14] sas-class: sas_discover.c Discover process
 (end devices)
Date: Tue, 13 Sep 2005 09:11:11 -0400
Message-ID: <4326CFEF.2000005@adaptec.com>
References: <20050910024454.20602.qmail@web51613.mail.yahoo.com> <1126368081.4813.46.camel@mulgrave> <4325997D.3050103@adaptec.com> <20050912162739.GA11455@us.ibm.com> <4326964B.9010503@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932645AbVIMNLc@vger.kernel.org>
In-Reply-To: <4326964B.9010503@torque.net>
Sender: linux-kernel-owner@vger.kernel.org
To: dougg@torque.net
Cc: Patrick Mansfield <patmans@us.ibm.com>, James Bottomley <James.Bottomley@SteelEye.com>, ltuikov@yahoo.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 09/13/05 05:05, Douglas Gilbert wrote:
> The technique of supporting REPORT_LUNS on lun 0 of
> a target in the case where there is no such device
> (logical unit) is a pretty ugly. It also indicates what
> is really happening: the target device intercepts
> REPORT_LUNS, builds the response and replies on behalf
> of lun 0.
> 
> Turns out there are other reasons an application may want
> to "talk" to a target device rather than one of its logical
> units (e.g. access controls and log pages specific to
> the target's transport). Well known lus can be seen with the
> REPORT_LUNS (select_report=1) but there is no mechanism (that
> I am aware of) that allows anyone to access them
> from the user space with linux.
> 
> 
> References at www.t10.org:
>    spc4r01a.pdf  [section 8]
>    bcc-r00.pdf   [bridge controller commands]

Well, I'm certainly glad that Doug is getting involved
and on a SCSI professional level (quoting specs etc.).

We need more SAM (SCSI-3) expertise in linux-scsi and
linux-kernel.

	Luben
