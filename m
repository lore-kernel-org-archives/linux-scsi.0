From: "Praveen Murali" <pmurali@logicube.com>
Subject: Re: [PATCH 3/3] Fix device detection issues with mvsas driver
Date: Tue, 15 Oct 2013 19:40:20 -0700
Message-ID: <7B4019BE-6198-47EF-804B-A7EF9889A22D@logicube.com>
References: <1340044537.3712.23.camel@praveen-debian.lg.local> <CAA9_cmeo=2Jjyp2DSwBDM=toTydMbLHJ+J7h2UXQYb2YmV+tzg@mail.gmail.com> <1340296918.3712.54.camel@praveen-debian.lg.local> <CABE8wwtUE7ZvR=zYGc+HCL8tUi3QE2N+-k1UP+8ow9MYk-kWGg@mail.gmail.com> <1340298338.3712.55.camel@praveen-debian.lg.local> <CAA9_cmf5PwhE7XizaTwx8TdbEBYKsLyES-Gc75n-VoUXhKTtgg@mail.gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p01c11o145.mxlogic.net ([208.65.144.68]:58202 "EHLO
	p01c11o145.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab3JPCkd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Oct 2013 22:40:33 -0400
In-Reply-To: <CAA9_cmf5PwhE7XizaTwx8TdbEBYKsLyES-Gc75n-VoUXhKTtgg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, JBottomley@parallels.com

Yes, I checked that today and was meaning to ask you about it. :)

> On Oct 15, 2013, at 6:31 PM, "Dan Williams" <dan.j.williams@intel.com> wrote:
> 
>> On Thu, Jun 21, 2012 at 10:05 AM, Praveen Murali <pmurali@logicube.com> wrote:
>> here is the updated patch.
>> 
>>> On Thu, 2012-06-21 at 09:48 -0700, Dan Williams wrote:
>>>> On Thu, Jun 21, 2012 at 9:41 AM, Praveen Murali <pmurali@logicube.com> wrote:
>>>> Ok, do you want me to regenerate the patch?
>>> 
>>> Yes, James will be the one to ultimately apply it and would save him
>>> time to have a new patch.  The patch you attached had a shorter
>>> changelog I think it would be fine to include your entire 4 paragraph
>>> lead in message.
> 
> Hi Praveen,
> 
> Your last message prompted me to look back in my archives and I found
> this patch which does not appear to be upstream yet.  I assume it is
> still needed?
> 
> --
> Dan
