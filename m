From: Valentin Rothberg <valentinrothberg@gmail.com>
Subject: Re: [PATCH] drivers/scsi/arm/acornscsi.c: rename CONFIG_ACORNSCSI_CONSTANTS
Date: Tue, 28 Apr 2015 21:26:18 +0200
Message-ID: <CAD3Xx4LMZudtWBajjpNgLjXbCKmiAq9YyMZwMNn=5=5w_1vCPQ@mail.gmail.com>
References: <1430230511-10869-1-git-send-email-valentinrothberg@gmail.com> <1430248224.2411.68.camel@x220>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1430248224.2411.68.camel@x220>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Bolle <pebolle@tiscali.nl>
Cc: JBottomley@odin.com, linux@arm.linux.org.uk, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Paul,

On Tue, Apr 28, 2015 at 9:10 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> On Tue, 2015-04-28 at 16:15 +0200, Valentin Rothberg wrote:
>> CONFIG_ACORNSCSI_CONSTANTS is a file local CPP identifier and thereby
>> violates the naming convention of Kconfig options in Make and CPP
>> syntax; only Kconfig options should carry the 'CONFIG_' prefix.
>>
>> This patch removes the 'CONFIG_' prefix to apply to this convention and
>> to make static analysis tools happy.
>
> Will the Erlangen bot still spot ACORNSCSI_CONSTANTS as a potential
> issue?

No, undertaker-checkpatch won't complain about this.  There are
thousands of such cases (i.e., without CONFIG_ prefix) around in the
code (mostly #ifdef DEBUG).  But most of them are intentionally dead
or related to debugging, so they are ignored to avoid having false
positives.

Regards,
 Valentin

> Paul Bolle
>
