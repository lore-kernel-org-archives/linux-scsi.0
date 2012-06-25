From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v6 02/11] libata: bind the Linux device tree to the ACPI
 device tree
Date: Mon, 25 Jun 2012 12:22:01 -0700
Message-ID: <CABE8wwsj+LOpgWE2f==n38OGJwWDoGbFk7pEsL9g3vP599KVGg@mail.gmail.com>
References: <1340611992-41457-1-git-send-email-ming.m.lin@intel.com>
	<1340611992-41457-3-git-send-email-ming.m.lin@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1340611992-41457-3-git-send-email-ming.m.lin@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Aaron Lu <aaron.lu@amd.com>, Holger Macht <holger@homac.de>, Matthew Garrett <mjg@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, David Woodhouse <David.Woodhouse@intel.com>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Jun 25, 2012 at 1:13 AM, Lin Ming <ming.m.lin@intel.com> wrote:
> From: Matthew Garrett <mjg@redhat.com>
>
> Associate the ACPI device tree and libata devices.
> This patch uses the generic ACPI glue framework to do so.
>
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> Signed-off-by: Holger Macht <holger@homac.de>
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
