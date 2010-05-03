From: James Bottomley <James.Bottomley@suse.de>
Subject: RE: [PATCH 1/3 ] SCSI: Support HW reset for EH and polling scheme
 for scsi device(This is correct revision, please ignore last one)
Date: Mon, 03 May 2010 09:13:18 -0400
Message-ID: <1272892398.4369.18.camel@mulgrave.site>
References: <5B75F1A9B45A486E8A44B035EDCC381E@areca4e4f859d4>
	 <1272891585.4369.15.camel@mulgrave.site>
	 <4FF3529D44A744779DF0EA4F2A39941F@areca4e4f859d4>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4FF3529D44A744779DF0EA4F2A39941F@areca4e4f859d4>
Sender: linux-kernel-owner@vger.kernel.org
To: nick.cheng@areca.com.tw
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2010-05-03 at 21:11 +0800, Nick Cheng wrote:
> Do you compile the code after applying all of three patches?

No, this is after applying the first one.  The patch series has to be
bisectable, which means they all have to be individually compilable (and
individually functional).

James
