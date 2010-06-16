From: Julian Calaby <julian.calaby@gmail.com>
Subject: Re: [PATCH 0/5] Fix set but unused variable warnings
Date: Wed, 16 Jun 2010 15:52:58 +1000
Message-ID: <AANLkTikwKHITQJDaSf9BnHQ9FLiQ-KYlCWNiH438otsV@mail.gmail.com>
References: <1276666434-11227-1-git-send-email-justinmattock@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46675 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756290Ab0FPFxT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Jun 2010 01:53:19 -0400
In-Reply-To: <1276666434-11227-1-git-send-email-justinmattock@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Jun 16, 2010 at 15:33, Justin P. Mattock
<justinmattock@gmail.com> wrote:
> Here is another set of patches fixing some warning messages generated
> when building the kernel when using gcc 4.6.0.
>
> This set just focuses in on the variables warnings that are reported
> to be unused. Keep in mind there are still lots more warning messages
> that I'm seeing, and will try my hardest to see if I can come up with
> a fix, but if things become too difficult and so forth then a bug should
> be filled etc..

Given that patches 3, 4 and 5 seem to be a cases of missing error
handling, (3 and 4 in particular seem to be breaking things rather
than fixing them) in my humble opinion, I think this set needs some
work and discussion.

Justin, maybe you'd be better off posting the actual error messages
(split up by subsystem) and letting the lists discuss them, rather
than posting patches which are obviously wrong. (like the ones I've
pointed out)

I'm sure that everyone here is as committed as you are to eliminating
compile warnings and errors and, in my opinion, more good will come
from a healthy discussion of the warnings than maintainers NAKing your
patches out of hand.

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
.Plan: http://sites.google.com/site/juliancalaby/
