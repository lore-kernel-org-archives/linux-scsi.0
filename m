From: Adrian Palmer <adrian.palmer@seagate.com>
Subject: Re: [LSF/MM TOPIC] - SMR Modifications to EXT4 (and other generic
 file systems)
Date: Tue, 13 Jan 2015 13:32:26 -0700
Message-ID: <CAKdFiL6XVxq-mjJd2TMkoEyE4kss5yTfWGKyeY-EZa2NDyLwFw@mail.gmail.com>
References: <CAKdFiL6CMHTHWCvSFjFNw6hzvPLDEWWAC-o3wdivq9co7SX1FA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CAKdFiL6CMHTHWCvSFjFNw6hzvPLDEWWAC-o3wdivq9co7SX1FA@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: lsf-pc@lists.linux-foundation.org
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This seemed to bounce on most of the lists to which it originally
sent.  I'm resending..

I've uploaded an introductory design document at
https://github.com/Seagate/SMR_FS-EXT4. I'll update regularly.  Please
feel free to send questions my way.

It seems there are many sub topics requested related to SMR for this conference.

Adrian

On Tue, Jan 6, 2015 at 4:29 PM, Adrian Palmer <adrian.palmer@seagate.com> wrote:
> I agree wholeheartedly with Dr. Reinecke in discussing what is becoming my
> favourite topic also. I support the need for generic filesystem support with
> SMR and ZAC/ZBC drives.
>
> Dr. Reinecke has already proposed a discussion on the ZAC/ZBC
> implementation.  As a complementary topic, I want to discuss the generic
> filesystem support for Host Aware (HA) / Host Managed (HM) drives.
>
> We at Seagate are developing an SMR Friendly File System (SMRFFS) for this
> very purpose.  Instead of a new filesystem with a long development time, we
> are implementing it as an HA extension to EXT4 (and WILL be backwards
> compatible with minimal code paths).  I'll be talking about the the on-disk
> changes we need to consider as well as the needed kernel changes common to
> all generic filesystems.  Later, we intend to evaluate the work for use in
> other filesystems and kernel processes.
>
> I'd like to host a discussion of SMRFFS and ZAC for consumer and cloud
> systems at LSF/MM. I want to gather community consensus at LSF/MM of the
> required technical kernel changes before this topic is presented at Vault.
>
> Subtopics:
>
> On-disk metadata structures and data algorithms
> Explicit in-order write requirement and a look at the IO stack
> New IOCTLs to call from the FS and the need to know about the underlying
> disk -- no longer completely disk agnostic
>
>
> Adrian Palmer
> Firmware Engineer II
> R&D Firmware
> Seagate, Longmont Colorado
> 720-684-1307
