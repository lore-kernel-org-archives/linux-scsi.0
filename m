From: Rajat Jain <rajatja@google.com>
Subject: Re: [PATCH] Documentation/scsi: Documentation about scsi_cmnd lifecycle
Date: Tue, 9 Jun 2015 09:48:54 -0700
Message-ID: <CACK8Z6G1c8iJz7RwA6nPFzT66G9ujX7YWCZshgU0uqi_LqrLZA@mail.gmail.com>
References: <1431466426-15712-1-git-send-email-rajatja@google.com>
	<20150513153652.1868bc3c@lwn.net>
	<CACK8Z6HJ1kigCZ=DKuTVrDfDiwRLa49EVNJUPzDR_nqvog-B3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ie0-f175.google.com ([209.85.223.175]:33198 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167AbbFIQsy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jun 2015 12:48:54 -0400
Received: by iebgx4 with SMTP id gx4so18188108ieb.0
        for <linux-scsi@vger.kernel.org>; Tue, 09 Jun 2015 09:48:54 -0700 (PDT)
In-Reply-To: <CACK8Z6HJ1kigCZ=DKuTVrDfDiwRLa49EVNJUPzDR_nqvog-B3Q@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jonathan Corbet <corbet@lwn.net>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-doc@vger.kernel.org, Rajat Jain <rajatxjain@gmail.com>, linux-kernel@vger.kernel.org

Hello James,

On Tue, May 26, 2015 at 11:15 AM, Rajat Jain <rajatja@google.com> wrote:
> Hello James / linux-scsi folks,
>
> On Wed, May 13, 2015 at 12:36 PM, Jonathan Corbet <corbet@lwn.net> wrote:
>> On Tue, 12 May 2015 14:33:46 -0700
>> Rajat Jain <rajatja@google.com> wrote:
>>
>>> Add documentation to describe the various scenarios that the scsi_cmnd
>>> may go through in its life time in the mid level driver - aborts,
>>> failures, retries, error handling etc. The documentation has lots of
>>> details including examples.
>>
>> So this seems like useful stuff.  I'd be happy to take it through the
>> docs tree, but it definitely needs an ack or two from the SCSI camp first.
>
> I was wondering if someone could please help in reviewing this SCSI
> documentation?
>

Can you please help review this SCSI documentation?

Thanks,

Rajat
