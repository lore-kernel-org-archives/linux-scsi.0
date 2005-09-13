From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH 2.6.13 2/14] sas-class: README
Date: Tue, 13 Sep 2005 10:29:31 -0400
Message-ID: <4326E24B.6030000@adaptec.com>
References: <4321E4DD.7070405@adaptec.com> <432543C6.1020403@torque.net> <4325CB10.1020902@adaptec.com> <4326A635.3020400@torque.net> <4326D48E.1080305@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S964798AbVIMO3k@vger.kernel.org>
In-Reply-To: <4326D48E.1080305@adaptec.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dougg@torque.net
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 09/13/05 09:30, Luben Tuikov wrote:
> I cannot call it a "passthrough" since the SMP frame isn't
> "passing though" (by passing) anything.  When userspace
> does a read(2) to get the data they expect, the SMP
> frame they wrote(2) is sent to the SDS immediately.
> In effect there is no "passing through".
> 
> It is a _protocol_ interjection.
> 
> That is an SMP frame (submission) _instantiates_
> at that layer/level, not lower, not higher.
> 
> 
>>one dispenses with a bit of metadata such as per command
>>timeouts and 3 levels of error messages (i.e. from the

I forgot to mention -- SMP transport has a hardware timer
as well as software one.  read(2) will never hang.

If there's no one on the other end, we get an error,
and read(2) less (or none) information than we requested.

	Luben
