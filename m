From: Matthias Eble <psychotrahe@gmail.com>
Subject: Re: Persistent reservation behaviour/compliance with redundant controllers
Date: Tue, 7 Jan 2014 00:35:48 +0100
Message-ID: <CAKbOo_KzSEimm_2dRKYY+WRmLqJ1R8f6fbr5rMvyr9TDAdLF6A@mail.gmail.com>
References: <CAKbOo_KMG+M8F06S4wo9vta6PJjpgXzMX9ri-vr=PY0QYASPLg@mail.gmail.com>
	<52CB2C44.7040503@suse.com>
	<CAKbOo_+LxN7UN11nxrD7pQ5Evffb-jdbW9BmPJ47NWiSXG-=nQ@mail.gmail.com>
	<1389049579.2811.12.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:57733 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933194AbaAFXfw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jan 2014 18:35:52 -0500
Received: by mail-lb0-f178.google.com with SMTP id c11so10151938lbj.23
        for <linux-scsi@vger.kernel.org>; Mon, 06 Jan 2014 15:35:50 -0800 (PST)
In-Reply-To: <1389049579.2811.12.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Lee Duncan <lduncan@suse.com>, linux-scsi@vger.kernel.org

2014/1/7 James Bottomley <James.Bottomley@hansenpartnership.com>:
> On Mon, 2014-01-06 at 23:53 +0100, Matthias Eble wrote:
>>
>> Can sdg and sdl be the same I_T_Nexus at a time?
>> Right now, they are handled like that.
>> In my understanding, every scsi disk device represents an I_T_Nexus.
>
> No, every SCSI disk is an I_T_L nexus.  There's no actual device object
> in Linux for an I_T nexus.

So, PR registrations are made for an I_T nexus using an I_T_L nexus.
Probably my previous systems had a 1:1 relation between I_T and I_T_L.

Is there a way to identify which I_T_L nexuses belong to the same I_T nexus?
