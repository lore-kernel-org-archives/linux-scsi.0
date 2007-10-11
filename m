From: Rob Landley <rob@landley.net>
Subject: Re: [2.6 patch] esp_scsi.c: remove __dev{init,exit}
Date: Thu, 11 Oct 2007 17:47:02 -0500
Message-ID: <200710111747.03119.rob@landley.net>
References: <200710110552.49129.rob@landley.net> <1192109439.3352.11.camel@localhost.localdomain> <20071011153520.GA16424@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <20071011153520.GA16424@stusta.de>
Content-Disposition: inline
Sender: sparclinux-owner@vger.kernel.org
To: Adrian Bunk <bunk@kernel.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>
List-Id: linux-scsi@vger.kernel.org

On Thursday 11 October 2007 10:35:20 am Adrian Bunk wrote:
> Since scsi_esp_{,un}register() are EXPORT_SYMBOL'ed, these functions
> (and the functions they use) can't be __dev{init,exit}.
>
> Based on a bug report by Rob Landley.
>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Acked-by: Rob Landley <rob@landley.net>

Worked for me...

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
