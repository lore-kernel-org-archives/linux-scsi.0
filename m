From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] Documentation/scsi: Documentation about scsi_cmnd
 lifecycle
Date: Wed, 13 May 2015 15:36:52 -0400
Message-ID: <20150513153652.1868bc3c@lwn.net>
References: <1431466426-15712-1-git-send-email-rajatja@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1431466426-15712-1-git-send-email-rajatja@google.com>
Sender: linux-doc-owner@vger.kernel.org
To: Rajat Jain <rajatja@google.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org, Rajat Jain <rajatxjain@gmail.com>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 12 May 2015 14:33:46 -0700
Rajat Jain <rajatja@google.com> wrote:

> Add documentation to describe the various scenarios that the scsi_cmnd
> may go through in its life time in the mid level driver - aborts,
> failures, retries, error handling etc. The documentation has lots of
> details including examples.

So this seems like useful stuff.  I'd be happy to take it through the
docs tree, but it definitely needs an ack or two from the SCSI camp first.

Taking another pass through to clean up typographical errors and trivial
language issues would probably be a good thing to do as well.

Thanks,

jon
