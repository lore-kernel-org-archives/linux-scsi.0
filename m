From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: [PATCH 2/2] libata-scsi: better style in ata_msense_caching()
Date: Thu, 7 Jul 2016 20:44:34 +0800
Message-ID: <CAGnHSE=kH9f_2D3Sjc9qptBa344w_qebdncSrfMq_vW6stVq2A@mail.gmail.com>
References: <577db3cf.0a6a620a.c3774.1508@mx.google.com> <b7d33126-814b-60c2-8699-0e63bbf42834@cogentembedded.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <b7d33126-814b-60c2-8699-0e63bbf42834@cogentembedded.com>
Sender: linux-ide-owner@vger.kernel.org
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Sorry I am a bit new in this. Does that mean I should also use {} for
the if clause even it has only one line of statement, because I
(needed to) use that for the else clause? So it should be like:

if ... {
    ...
} else {
    ...
    ...
}

On 7 July 2016 at 18:55, Sergei Shtylyov
<sergei.shtylyov@cogentembedded.com> wrote:
>
>    CodingStyle: {} should be used in all branches if used in at least one.
>
> MBR, Sergei
>
