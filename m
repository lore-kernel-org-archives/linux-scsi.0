From: Bob Tracy <rct@gherkin.frus.com>
Subject: Re: [PATCH] sg: fix oops in the error path in sg_build_indirect()
Date: Thu, 3 Sep 2009 09:41:26 -0500
Message-ID: <20090903144126.GA22411@gherkin.frus.com>
References: <20090903033945.GA20755@gherkin.frus.com> <20090903142708.0b820ca1@leela>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754561AbZICOl0@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090903142708.0b820ca1@leela>
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Schmidt <mschmidt@redhat.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stable@kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Sep 03, 2009 at 02:27:08PM +0200, Michal Schmidt wrote:
> When the allocation fails in sg_build_indirect(), an oops happens in
> the error path. It's caused by an obvious typo.
> 
> Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
> Reported-by: Bob Tracy <rct@gherkin.frus.com>

ACK, and thanks.

--Bob
