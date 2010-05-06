From: Sean Thomson <psthomso@hotmail.com>
Subject: RE: libsas: is there a current maintainer?
Date: Thu, 6 May 2010 16:49:35 -0700
Message-ID: <SNT126-W303C2E96A4B7219BD10B2ACEF50@phx.gbl>
References: <SNT126-W15ED7713879FB6E952A2DECEF40@phx.gbl>
 <1273069012.5227.64.camel@mulgrave.site>,<7964E35BEEE14ED4B261A4EE77D5C7F1@usish.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from snt0-omc4-s12.snt0.hotmail.com ([65.55.90.215]:39105 "EHLO
	snt0-omc4-s12.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752933Ab0EFXtg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 May 2010 19:49:36 -0400
In-Reply-To: <7964E35BEEE14ED4B261A4EE77D5C7F1@usish.com.cn>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jack_wang@usish.com, james.bottomley@suse.de
Cc: linux-scsi@vger.kernel.org


As I understand things, there were two new BCN's that were
added in 2.x, and I'm thinking that to support them might require some
additons to libsas. If I need to support them, I can do that work when
the time comes.
 
Thanks guys, I appreciate your time and answers!


----------------------------------------
> From: jack_wang@usish.com
> To: James.Bottomley@suse.de; psthomso@hotmail.com
> CC: linux-scsi@vger.kernel.org
> Subject: RE: libsas: is there a current maintainer?
> Date: Thu, 6 May 2010 12:37:43 +0800
>
>
>
> On Wed, 2010-05-05 at 07:07 -0700, Sean Thomson wrote:
>> This is mostly a curiosity question, but who is maintaining libsas?
>
> There's no overall maintainer, it's jointly maintained by its users.
>
>> I'm just starting work on a new sas driver and wondering if it is
>> necessary for anything to be done to make it (or if it is already) 2.1
>> compliant
>
> I don't quite understand the question. libsas is a software library and
> 2.1 is a physical layer document ... there's not much overlap.
>
> To answer what I think the question is about, libsas is only coded to
> 1.1 ... the expander checking has been relaxed a bit, so it shouldn't
> barf on a 2.0 configuration, but I'm not aware that anyone's actually
> tested it with a self configuring expander.
>
> James
>
> [Jack]We had test it on PMC-Sierra's SAS2 expanders, the main issue is
> expander checking as you mentioned, and we can remove the the T-T limitation
> in function sas_check_parent_topology. The other problem is zone support,
> when we change zone setting, the libsas can not find the change. I'm not
> have
> much time to dig in.
> Thanks
> 		 	   		  
_________________________________________________________________
The New Busy think 9 to 5 is a cute idea. Combine multiple calendars with Hotmail. 
http://www.windowslive.com/campaign/thenewbusy?tile=multicalendar&ocid=PID28326::T:WLMTAGL:ON:WL:en-US:WM_HMP:042010_5