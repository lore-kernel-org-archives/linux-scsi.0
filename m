From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC V1 0/4] Add support for pci/non-pci probing for UFS
Date: Wed, 16 May 2012 08:44:37 +0100
Message-ID: <1337154277.2985.8.camel@dabdike.int.hansenpartnership.com>
References: <1337083436-4204-1-git-send-email-girish.shivananjappa@linaro.org>
	 <CAKYAXd91z1obe+QjEsp8Bzjore-7jMCdMg-K4DgO8c6a7=8j8A@mail.gmail.com>
	 <CAGxe1ZGhmM65KKyPQR12ZpZ4KHzb8NPTrJk9vQTaX8TN_idiBQ@mail.gmail.com>
	 <CAGxe1ZGo-i2pNNteTh-Eo7G-9dmqF2tPwND3DHvpw7Se6_CTOg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:56710 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759537Ab2EPHol (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 May 2012 03:44:41 -0400
In-Reply-To: <CAGxe1ZGo-i2pNNteTh-Eo7G-9dmqF2tPwND3DHvpw7Se6_CTOg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Girish K S <girish.shivananjappa@linaro.org>
Cc: Namjae Jeon <linkinjeon@gmail.com>, linux-scsi@vger.kernel.org, vinholikatti@gmail.com, santoshsy@gmail.com, patches@linaro.org

On Wed, 2012-05-16 at 11:40 +0530, Girish K S wrote:
> Hi James / maintainers,
> can you please confirm whether the patches have to be rebased to
> James's for-next / Linux-next branch.

For patches which conflict with others on the list, you need to sort out
with the maintainers of the driver what the sequencing is going to be.
They're the ones who make the final decision.

Just as a side note, I usually won't add patches for a driver to the
scsi git tree until it's been acked by a maintainer of that driver (or
taken up and incorporated into a patch set the maintainer sends on to
me).

James


