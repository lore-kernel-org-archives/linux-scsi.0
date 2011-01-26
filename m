From: adam radford <aradford@gmail.com>
Subject: Re: 3w-sas 0000:02:00.0: vpd r/w failed.
Date: Wed, 26 Jan 2011 12:34:06 -0800
Message-ID: <AANLkTikECrLeVGQt6ui0eHVdohgtW7-ksetrsKp4sRNw@mail.gmail.com>
References: <alpine.DEB.2.00.1101261444130.32464@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1101261444130.32464@p34.internal.lan>
Sender: linux-kernel-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jan 26, 2011 at 11:45 AM, Justin Piszcz <jpiszcz@lucidpixels.co=
m> wrote:
>
> [475380.769837] 3w-sas 0000:02:00.0: vpd r/w failed. =A0This is likel=
y a
> firmware bug on this device. =A0Contact the card vendor for a firmwar=
e update.
>

Justin,

pci_vpd_pci22_wait() uses 'HZ' and time_after() to detect a timeout of
reading the vpd.

Do you have your kernel compiled with the following?

-# CONFIG_NO_HZ is not set
-# CONFIG_ACPI_PROCESSOR is not set
-# CONFIG_CPU_FREQ is not set

-Adam
