From: Rajat Jain <rajatja@google.com>
Subject: Re: [PATCH] Documentation/scsi: Documentation about scsi_cmnd lifecycle
Date: Tue, 26 May 2015 11:15:12 -0700
Message-ID: <CACK8Z6HJ1kigCZ=DKuTVrDfDiwRLa49EVNJUPzDR_nqvog-B3Q@mail.gmail.com>
References: <1431466426-15712-1-git-send-email-rajatja@google.com>
	<20150513153652.1868bc3c@lwn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20150513153652.1868bc3c@lwn.net>
Sender: linux-doc-owner@vger.kernel.org
To: Jonathan Corbet <corbet@lwn.net>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-doc@vger.kernel.org, Rajat Jain <rajatxjain@gmail.com>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello James / linux-scsi folks,

On Wed, May 13, 2015 at 12:36 PM, Jonathan Corbet <corbet@lwn.net> wrote:
> On Tue, 12 May 2015 14:33:46 -0700
> Rajat Jain <rajatja@google.com> wrote:
>
>> Add documentation to describe the various scenarios that the scsi_cmnd
>> may go through in its life time in the mid level driver - aborts,
>> failures, retries, error handling etc. The documentation has lots of
>> details including examples.
>
> So this seems like useful stuff.  I'd be happy to take it through the
> docs tree, but it definitely needs an ack or two from the SCSI camp first.

I was wondering if someone could please help in reviewing this SCSI
documentation?

Thanks,

Rajat
